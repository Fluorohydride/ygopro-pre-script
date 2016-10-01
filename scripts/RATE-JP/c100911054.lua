--十二獣ワイルドボウ
--Juunishishi Wildbow
--Script by mercury233
function c100911054.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,5,c100911054.ovfilter,aux.Stringid(100911054,0),5,c100911054.xyzop)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c100911054.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c100911054.defval)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100911054,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(c100911054.condition)
	e3:SetTarget(c100911054.target)
	e3:SetOperation(c100911054.operation)
	c:RegisterEffect(e3)
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e4)
end
function c100911054.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1f2) and not c:IsCode(100911054)
end
function c100911054.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,100911054)==0 end
	Duel.RegisterFlagEffect(tp,100911054,RESET_PHASE+PHASE_END,0,1)
end
function c100911054.atkfilter(c)
	return c:IsSetCard(0x1f2) and c:GetAttack()>=0
end
function c100911054.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c100911054.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c100911054.deffilter(c)
	return c:IsSetCard(0x1f2) and c:GetDefense()>=0
end
function c100911054.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c100911054.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c100911054.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetOverlayCount()>=12
end
function c100911054.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_ONFIELD)
	local sg=g:Filter(Card.IsAbleToGrave,nil)
	if chk==0 then return sg:GetCount()>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c100911054.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SendtoGrave(g,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	if og:GetCount()>0 then
		Duel.BreakEffect()
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
		end
	end
end
