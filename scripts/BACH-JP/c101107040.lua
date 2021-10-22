--ガーディアン・キマイラ
--
--Script by JoyJ
function c101107040.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,false,c101107040.fmat1,c101107040.fmat2,c101107040.fmat3)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101107040,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101107040.drcon)
	e1:SetTarget(c101107040.drtg)
	e1:SetOperation(c101107040.drop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c101107040.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function c101107040.fmat1(c,fc,sub,mg,sg)
	return c:IsLocation(LOCATION_HAND) and c101107040.fmat3(c,fc,sub,mg,sg)
end
function c101107040.fmat2(c,fc,sub,mg,sg)
	return c:IsLocation(LOCATION_ONFIELD) and c101107040.fmat3(c,fc,sub,mg,sg)
end
function c101107040.fmat3(c,fc,sub,mg,sg)
	return not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode())
end
function c101107040.drcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL)
end
function c101107040.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local dr,des=e:GetLabel()
	if chk==0 then return c:IsSummonType(TYPE_FUSION) and dr and des and Duel.IsPlayerCanDraw(tp,dr)
		and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>=des end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,dr,tp,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(dr)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,des,1-tp,LOCATION_ONFIELD)
end
function c101107040.drop(e,tp,eg,ep,ev,re,r,rp)
	local _,des=e:GetLabel()
	local _,_,dp,dr=Duel.GetOperationInfo(0,CATEGORY_DRAW)
	if Duel.Draw(dp,dr,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,des,des,nil)
		if #g==des then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c101107040.valcheck(e,c)
	local mg=c:GetMaterial()
	local mg1=mg:Filter(Card.IsPreviousLocation,nil,LOCATION_HAND)
	local mg2=mg:Filter(Card.IsPreviousLocation,nil,LOCATION_ONFIELD)
	e:GetLabelObject():SetLabel(#mg1,#mg2)
end
