--サイバース・アクセラレーター
--Cyberse Accelerator
--Scripted by Eerie Code
function c100209001.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.NOT(aux.FilterBoolFunction(Card.IsLinkType,TYPE_TOKEN)),2)
	--target
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100209001,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100209001)
	e1:SetCondition(c100209001.condition)
	e1:SetCost(c100209001.cost)
	e1:SetTarget(c100209001.target)
	e1:SetOperation(c100209001.operation)
	c:RegisterEffect(e1)
end
function c100209001.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c100209001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c100209001.filter(c,lg)
	return c:IsFaceup() and c:IsRace(RACE_CYBERS) and lg and lg:IsContains(c)
end
function c100209001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=e:GetHandler():GetLinkedGroup()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c100209001.filter(chkc,lg) end
	if chk==0 then return Duel.IsExistingTarget(c100209001.filter,tp,LOCATION_MZONE,0,1,nil,lg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c100209001.filter,tp,LOCATION_MZONE,0,1,1,nil,lg)
	e:SetLabel(Duel.SelectOption(tp,aux.Stringid(100209001,1),aux.Stringid(100209001,2)))
end
function c100209001.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	if e:GetLabel()==0 then
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(2000)
	else
		e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
		e1:SetValue(1)
	end
	tc:RegisterEffect(e1)
end
