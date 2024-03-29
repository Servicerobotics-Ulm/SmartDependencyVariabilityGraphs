/**
 * generated by Xtext 2.21.0
 */
package org.xtext.dvg.formatting2;

import BbDvgTcl.BBContainer;
import BbDvgTcl.BuildingBlock;
import BbDvgTcl.DVG;
import BbDvgTcl.InputRelationship;
import BbDvgTcl.Output;
import BbDvgTcl.Pattern;
import BbDvgTcl.SharedResources;
import BbDvgTcl.VariabilityEntitySet;
import com.google.inject.Inject;
import java.util.Arrays;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.formatting2.AbstractFormatter2;
import org.eclipse.xtext.formatting2.IFormattableDocument;
import org.eclipse.xtext.resource.XtextResource;
import org.eclipse.xtext.xbase.lib.Extension;
import org.xtext.dvg.services.DvgDslGrammarAccess;

@SuppressWarnings("all")
public class DvgDslFormatter extends AbstractFormatter2 {
  @Inject
  @Extension
  private DvgDslGrammarAccess _dvgDslGrammarAccess;

  protected void _format(final DVG dVG, @Extension final IFormattableDocument document) {
    EList<Pattern> _pattern = dVG.getPattern();
    for (final Pattern pattern : _pattern) {
      document.<Pattern>format(pattern);
    }
    EList<BBContainer> _bbcontainer = dVG.getBbcontainer();
    for (final BBContainer bBContainer : _bbcontainer) {
      document.<BBContainer>format(bBContainer);
    }
  }

  protected void _format(final BuildingBlock buildingBlock, @Extension final IFormattableDocument document) {
    document.<VariabilityEntitySet>format(buildingBlock.getVes());
    EList<Output> _o = buildingBlock.getO();
    for (final Output output : _o) {
      document.<Output>format(output);
    }
    EList<InputRelationship> _ir = buildingBlock.getIr();
    for (final InputRelationship inputRelationship : _ir) {
      document.<InputRelationship>format(inputRelationship);
    }
    document.<SharedResources>format(buildingBlock.getSharedresources());
  }

  public void format(final Object buildingBlock, final IFormattableDocument document) {
    if (buildingBlock instanceof XtextResource) {
      _format((XtextResource)buildingBlock, document);
      return;
    } else if (buildingBlock instanceof BuildingBlock) {
      _format((BuildingBlock)buildingBlock, document);
      return;
    } else if (buildingBlock instanceof DVG) {
      _format((DVG)buildingBlock, document);
      return;
    } else if (buildingBlock instanceof EObject) {
      _format((EObject)buildingBlock, document);
      return;
    } else if (buildingBlock == null) {
      _format((Void)null, document);
      return;
    } else if (buildingBlock != null) {
      _format(buildingBlock, document);
      return;
    } else {
      throw new IllegalArgumentException("Unhandled parameter types: " +
        Arrays.<Object>asList(buildingBlock, document).toString());
    }
  }
}
