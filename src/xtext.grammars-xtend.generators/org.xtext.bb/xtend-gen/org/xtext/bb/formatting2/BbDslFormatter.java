/**
 * generated by Xtext 2.21.0
 */
package org.xtext.bb.formatting2;

import bbn.BuildingBlock;
import bbn.BuildingBlockDescription;
import bbn.Container;
import bbn.Decomposition;
import bbn.InputRelationship;
import bbn.Output;
import bbn.ResourceGroupId;
import bbn.SharedResources;
import bbn.VariabilityEntitySet;
import com.google.inject.Inject;
import java.util.Arrays;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.formatting2.AbstractFormatter2;
import org.eclipse.xtext.formatting2.IFormattableDocument;
import org.eclipse.xtext.resource.XtextResource;
import org.eclipse.xtext.xbase.lib.Extension;
import org.xtext.bb.services.BbDslGrammarAccess;

@SuppressWarnings("all")
public class BbDslFormatter extends AbstractFormatter2 {
  @Inject
  @Extension
  private BbDslGrammarAccess _bbDslGrammarAccess;

  protected void _format(final BuildingBlockDescription buildingBlockDescription, @Extension final IFormattableDocument document) {
    EList<BuildingBlock> _bb = buildingBlockDescription.getBb();
    for (final BuildingBlock buildingBlock : _bb) {
      document.<BuildingBlock>format(buildingBlock);
    }
    EList<Decomposition> _dt = buildingBlockDescription.getDt();
    for (final Decomposition decomposition : _dt) {
      document.<Decomposition>format(decomposition);
    }
    EList<Container> _c = buildingBlockDescription.getC();
    for (final Container container : _c) {
      document.<Container>format(container);
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
    document.<ResourceGroupId>format(buildingBlock.getResourcegroupid());
  }

  public void format(final Object buildingBlock, final IFormattableDocument document) {
    if (buildingBlock instanceof XtextResource) {
      _format((XtextResource)buildingBlock, document);
      return;
    } else if (buildingBlock instanceof BuildingBlock) {
      _format((BuildingBlock)buildingBlock, document);
      return;
    } else if (buildingBlock instanceof BuildingBlockDescription) {
      _format((BuildingBlockDescription)buildingBlock, document);
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
