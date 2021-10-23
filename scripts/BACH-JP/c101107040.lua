--ガーディアン・キマイラ
--
--Script by JoyJ & mercury233
function c101107040.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c101107040.ffilter,3,false)
	--material limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_MATERIAL_LIMIT)
	e0:SetValue(c101107040.matlimit)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c101107040.splimit)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101107040,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c101107040.drcon)
	e2:SetTarget(c101107040.drtg)
	e2:SetOperation(c101107040.drop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c101107040.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c101107040.indcon)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
end
function c101107040.ffilter(c,fc,sub,mg,sg)
	if not sg then return true end
	return not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode())
		and #sg<2 or sg:IsExists(aux.NOT(Card.IsLocation),1,c,c:GetLocation())
end
function c101107040.matlimit(e,c,fc,st)
	if st~=SUMMON_TYPE_FUSION then return true end
	return c:IsLocation(LOCATION_HAND) or c:IsControler(fc:GetControler()) and c:IsLocation(LOCATION_MZONE)
end
function c101107040.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
		or st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION
end
function c101107040.drcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActiveType(TYPE_SPELL)
end
function c101107040.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local dr,des=e:GetLabel()
	if chk==0 then return c:IsSummonType(SUMMON_TYPE_FUSION) and dr and des and Duel.IsPlayerCanDraw(tp,dr)
		and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>=des end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,dr,tp,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(dr)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101107040.drop(e,tp,eg,ep,ev,re,r,rp)
	local dr,des=e:GetLabel()
	if Duel.Draw(tp,dr,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,des,des,nil)
		if #g==des then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c101107040.valcheck(e,c)
	local mg=c:GetMaterial()
	local mg1=mg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	local mg2=mg:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
	e:GetLabelObject():SetLabel(#mg1,#mg2)
end
function c101107040.indcon(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,24094653)
end
